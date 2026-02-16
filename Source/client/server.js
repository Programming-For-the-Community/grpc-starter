const express = require('express');
const path = require('path');
const fs = require('fs');
const http = require('http');
const https = require('https');
const grpc = require('@grpc/grpc-js');
const protoLoader = require('@grpc/proto-loader');

// Load .env.dev if it exists
const envFilePath = path.join(__dirname, '.env.dev');
if (fs.existsSync(envFilePath)) {
  console.log('[ENV] Loading .env.dev file...');
  const envContent = fs.readFileSync(envFilePath, 'utf8');
  envContent.split('\n').forEach(line => {
    line = line.trim();
    // Skip empty lines and comments
    if (!line || line.startsWith('#')) return;

    const [key, ...valueParts] = line.split('=');
    if (key && valueParts.length > 0) {
      const value = valueParts.join('=').trim();
      // Only set if not already in process.env
      if (!process.env[key]) {
        process.env[key] = value;
        console.log(`[ENV] Set ${key}=${value}`);
      }
    }
  });
  console.log('[ENV] .env.dev loaded successfully');
} else {
  console.log('[ENV] .env.dev not found, using existing environment variables');
}

const app = express();
const PORT = process.env.APP_PORT || 8081;
const HOST = process.env.APP_HOST || 'localhost';
const NAME = process.env.APP_NAME || 'flutter-web-client';
const VERSION = process.env.APP_VERSION || '0.0.1';
const BUILD_DIR = path.join(__dirname, 'build/web');
const SECURE = process.env.SERVER_SECURE === 'true';

// gRPC Configuration
const GRPC_HOST = process.env.GRPC_HOST || 'localhost';
const GRPC_PORT = process.env.GRPC_PORT || '50051';
const GRPC_SECURE = process.env.GRPC_SECURE === 'true';
const PROTO_DIR = process.env.PROTO_DIR || path.join(__dirname, '../proto');

// Middleware to parse JSON bodies
app.use(express.json({ limit: '10mb' }));

// CORS & Security Headers Middleware
app.use((req, res, next) => {
  // CORS Headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS, PATCH');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Accept, Authorization');
  res.setHeader('Access-Control-Max-Age', '86400');
  res.setHeader('Access-Control-Allow-Credentials', 'true');

  // Cache Control - prevent caching of API responses
  res.setHeader('Cache-Control', 'no-cache, no-store, must-revalidate');
  res.setHeader('Pragma', 'no-cache');
  res.setHeader('Expires', '0');

  // Security Headers
  res.setHeader('X-Content-Type-Options', 'nosniff');
  res.setHeader('X-Frame-Options', 'DENY');
  res.setHeader('X-XSS-Protection', '1; mode=block');

  // Handle preflight requests
  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  next();
});

// gRPC Clients - will be initialized when server starts
let grpcClients = {
  health: null,
  tracker: null
};

// Initialize gRPC clients
function initializeGrpcClients() {
  try {
    console.log('[GRPC] Initializing gRPC clients...');
    console.log('[GRPC] GRPC_HOST:', GRPC_HOST);
    console.log('[GRPC] GRPC_PORT:', GRPC_PORT);
    console.log('[GRPC] PROTO_DIR:', PROTO_DIR);

    // Load health proto
    const healthProto = protoLoader.loadSync(path.join(PROTO_DIR, 'health.proto'), {
      keepCase: true,
      longs: String,
      enums: String,
      defaults: true,
      oneofs: true,
    });

    console.log('[GRPC] ✓ Health proto loaded');
    const healthPackage = grpc.loadPackageDefinition(healthProto);
    console.log('[GRPC] ✓ Health package loaded');

    // Create health service client
    const credentials = GRPC_SECURE
      ? grpc.credentials.createSsl()
      : grpc.credentials.createInsecure();

    grpcClients.health = new healthPackage.grpc.health.v1.Health(
      `${GRPC_HOST}:${GRPC_PORT}`,
      credentials
    );
    console.log('[GRPC] ✓ Health client created');

    // Load tracker proto
    const trackerProto = protoLoader.loadSync(path.join(PROTO_DIR, 'tracker.proto'), {
      keepCase: true,
      longs: String,
      enums: String,
      defaults: true,
      oneofs: true,
    });

    console.log('[GRPC] ✓ Tracker proto loaded');
    const trackerPackage = grpc.loadPackageDefinition(trackerProto);
    console.log('[GRPC] ✓ Tracker package loaded');
    console.log('[GRPC] Available packages:', Object.keys(trackerPackage));

    // Create tracker service client (adjust service name based on your proto)
    grpcClients.tracker = new trackerPackage.tracker.Tracker(
      `${GRPC_HOST}:${GRPC_PORT}`,
      credentials
    );

    console.log(`[GRPC] ✓ Tracker client created`);
    console.log(`[GRPC] ✓ gRPC clients initialized (${GRPC_HOST}:${GRPC_PORT})`);
    console.log(`[GRPC] ✓ Security: ${GRPC_SECURE ? 'TLS' : 'Insecure'}`);
    console.log(`[GRPC] ✓ grpcClients.health:`, grpcClients.health ? 'initialized' : 'null');
    console.log(`[GRPC] ✓ grpcClients.tracker:`, grpcClients.tracker ? 'initialized' : 'null');
  } catch (error) {
    console.error('[GRPC] [ERROR] Failed to initialize gRPC clients:', error);
    throw error;
  }
}

// Health check endpoint
app.get('/health', (req, res) => {
  try {
    res.status(200).json({
        name: NAME,
        version: VERSION,
        status: 'UP'
    });
  } catch (error) {
    console.error('[SERVER] [ERROR] Health check error:', error);
    res.status(500).json({ name: NAME, version: process.env.VERSION, status: 'DOWN', error: error.message });
  }
});


// gRPC Health Check Endpoint - proxy to gRPC server
app.post('/api/grpc/health/check', (req, res) => {
  try {
    const { service } = req.body;

    if (!grpcClients.health) {
      return res.status(503).json({ error: 'gRPC health service not available' });
    }

    grpcClients.health.check({ service: service || '' }, (error, response) => {
      if (error) {
        console.error('[GRPC] [ERROR] Health check failed:', error);
        return res.status(500).json({
          error: 'Health check failed',
          details: error.message
        });
      }

      res.status(200).json({
        status: response.status || 'UNKNOWN'
      });
    });
  } catch (error) {
    console.error('[SERVER] [ERROR] Health endpoint error:', error);
    res.status(500).json({ error: 'Health check error', details: error.message });
  }
});

// gRPC Generic Unary Proxy Endpoint
// Usage: POST /api/grpc/:service/:method
// Body: { request data }
app.post('/api/grpc/:service/:method', (req, res) => {
  try {
    const { service, method } = req.params;
    const requestData = req.body;

    // Validate service
    if (!grpcClients[service]) {
      return res.status(400).json({
        error: 'Invalid service',
        available: Object.keys(grpcClients)
      });
    }

    const client = grpcClients[service];

    // Convert method name from snake_case/kebab-case to camelCase
    const methodName = method
      .split(/[-_]/)
      .map((word, index) =>
        index === 0 ? word : word.charAt(0).toUpperCase() + word.slice(1)
      )
      .join('');

    if (typeof client[methodName] !== 'function') {
      return res.status(400).json({
        error: 'Method not found on service',
        service,
        method: methodName
      });
    }

    // Call the gRPC method
    client[methodName](requestData, (error, response) => {
      if (error) {
        console.error(`[GRPC] [ERROR] ${service}.${methodName}:`, error);
        return res.status(500).json({
          error: 'gRPC call failed',
          service,
          method: methodName,
          details: error.message
        });
      }

      res.status(200).json(response);
    });
  } catch (error) {
    console.error('[SERVER] [ERROR] gRPC proxy error:', error);
    res.status(500).json({ error: 'gRPC proxy error', details: error.message });
  }
});

// gRPC Generic Streaming Proxy Endpoint
// Usage: GET /api/grpc/:service/:method/stream?param=value
// Returns: Server-Sent Events (SSE) stream
app.get('/api/grpc/:service/:method/stream', (req, res) => {
  try {
    const { service, method } = req.params;
    const requestData = req.query; // Get parameters from query string

    // Validate service
    if (!grpcClients[service]) {
      return res.status(400).json({
        error: 'Invalid service',
        available: Object.keys(grpcClients)
      });
    }

    const client = grpcClients[service];

    // Convert method name from snake_case/kebab-case to camelCase
    const methodName = method
      .split(/[-_]/)
      .map((word, index) =>
        index === 0 ? word : word.charAt(0).toUpperCase() + word.slice(1)
      )
      .join('');

    if (typeof client[methodName] !== 'function') {
      return res.status(400).json({
        error: 'Method not found on service',
        service,
        method: methodName
      });
    }

    // Set up Server-Sent Events (SSE) headers
    res.setHeader('Content-Type', 'text/event-stream');
    res.setHeader('Cache-Control', 'no-cache');
    res.setHeader('Connection', 'keep-alive');
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('X-Accel-Buffering', 'no'); // Disable nginx buffering
    
    // Send initial comment to establish connection
    res.write(':ok\n\n');
    res.flushHeaders(); // Flush headers immediately

    // Call the gRPC streaming method
    const call = client[methodName](requestData);
    
    // Send keepalive comments every 30 seconds to prevent timeout
    const keepaliveInterval = setInterval(() => {
      try {
        res.write(':keepalive\n\n');
        if (res.flush) res.flush();
      } catch (error) {
        clearInterval(keepaliveInterval);
      }
    }, 30000);

    // Handle incoming stream data
    call.on('data', (data) => {
      try {
        console.log(`[GRPC] Received data from ${service}.${methodName}:`, JSON.stringify(data));
        res.write(`data: ${JSON.stringify(data)}\n\n`);
        if (res.flush) res.flush();
      } catch (error) {
        console.error(`[GRPC] [ERROR] Error writing stream data for ${service}.${methodName}:`, error);
      }
    });

    // Handle stream end
    call.on('end', () => {
      console.log(`[GRPC] ${service}.${methodName} stream ended`);
      clearInterval(keepaliveInterval);
      res.end();
    });

    // Handle stream errors
    call.on('error', (error) => {
      console.error(`[GRPC] [ERROR] ${service}.${methodName} stream error:`, error);
      clearInterval(keepaliveInterval);
      try {
        res.write(`event: error\n`);
        res.write(`data: ${JSON.stringify({ error: error.message })}\n\n`);
      } catch (e) {
        // Response may already be closed
      }
      res.end();
    });

    // Handle client disconnect
    req.on('close', () => {
      console.log(`[GRPC] Client disconnected from ${service}.${methodName} stream`);
      clearInterval(keepaliveInterval);
      call.cancel();
    });

  } catch (error) {
    console.error('[SERVER] [ERROR] gRPC streaming proxy error:', error);
    res.status(500).json({ error: 'Streaming error', details: error.message });
  }
});

// gRPC Tracker Endpoints - specific routes for common operations
app.post('/api/tracker/move-user', (req, res) => {
  try {
    if (!grpcClients.tracker) {
      return res.status(503).json({ error: 'Tracker service not available' });
    }

    const { username, x, y } = req.body;

    if (!username || x === undefined || y === undefined) {
      return res.status(400).json({ error: 'Missing required fields: username, x, y' });
    }

    grpcClients.tracker.moveUser({
      name: username
    }, (error, response) => {
      if (error) {
        console.error('[GRPC] [ERROR] moveUser failed:', error);
        return res.status(500).json({
          error: 'Failed to move user',
          details: error.message
        });
      }

      res.status(200).json(response);
    });
  } catch (error) {
    console.error('[SERVER] [ERROR] Move user endpoint error:', error);
    res.status(500).json({ error: 'Move user error', details: error.message });
  }
});

app.post('/api/tracker/create-user', (req, res) => {
  console.log('[DEBUG] /api/tracker/create-user route handler called');
  console.log('[DEBUG] Request body:', req.body);
  try {
    if (!grpcClients.tracker) {
      console.log('[DEBUG] Tracker service not available');
      return res.status(503).json({ error: 'Tracker service not available' });
    }

    const { username } = req.body;

    if (!username) {
      return res.status(400).json({ error: 'Missing required field: username' });
    }

    console.log(`[GRPC] Creating user: ${username}`);

    grpcClients.tracker.createUser({ name: username }, (error, response) => {
      if (error) {
        console.error('[GRPC] [ERROR] createUser failed:', error);
        return res.status(500).json({
          error: 'Failed to create user',
          details: error.message
        });
      }

      console.log(`[GRPC] User created successfully: ${username}`);
      res.status(200).json(response);
    });
  } catch (error) {
    console.error('[SERVER] [ERROR] Create user endpoint error:', error);
    res.status(500).json({ error: 'Create user error', details: error.message });
  }
});

app.post('/api/tracker/get-user', (req, res) => {
  console.log('[DEBUG] POST /api/tracker/create-user reached - route handler executing');
  console.log('[DEBUG] Request body:', JSON.stringify(req.body));
  try {
    if (!grpcClients.tracker) {
      console.log('[DEBUG] grpcClients.tracker is null/undefined');
      return res.status(503).json({ error: 'Tracker service not available' });
    }

    const { username } = req.body;

    if (!username) {
      return res.status(400).json({ error: 'Missing required field: username' });
    }

    console.log(`[GRPC] Getting user: ${username}`);

    grpcClients.tracker.getUser({ name: username }, (error, response) => {
      if (error) {
        console.error('[GRPC] [ERROR] getUser failed:', error);
        return res.status(500).json({
          error: 'Failed to get user',
          details: error.message
        });
      }

      res.status(200).json(response);
    });
  } catch (error) {
    console.error('[SERVER] [ERROR] Get user endpoint error:', error);
    res.status(500).json({ error: 'Get user error', details: error.message });
  }
});

app.post('/api/tracker/take-trip', (req, res) => {
  try {
    if (!grpcClients.tracker) {
      return res.status(503).json({ error: 'Tracker service not available' });
    }

    const { username } = req.body;

    if (!username) {
      return res.status(400).json({ error: 'Missing required field: username' });
    }

    console.log(`[GRPC] Taking trip for user: ${username}`);

    grpcClients.tracker.takeTrip({ name: username }, (error, response) => {
      if (error) {
        console.error('[GRPC] [ERROR] takeTrip failed:', error);
        return res.status(500).json({
          error: 'Failed to take trip',
          details: error.message
        });
      }

      console.log(`[GRPC] Trip completed for user: ${username}`);
      res.status(200).json(response);
    });
  } catch (error) {
    console.error('[SERVER] [ERROR] Take trip endpoint error:', error);
    res.status(500).json({ error: 'Take trip error', details: error.message });
  }
});

app.post('/api/tracker/get-users', (req, res) => {
  try {
    if (!grpcClients.tracker) {
      return res.status(503).json({ error: 'Tracker service not available' });
    }

    grpcClients.tracker.getUsers({}, (error, response) => {
      if (error) {
        console.error('[GRPC] [ERROR] getUsers failed:', error);
        return res.status(500).json({
          error: 'Failed to get users',
          details: error.message
        });
      }

      res.status(200).json(response);
    });
  } catch (error) {
    console.error('[SERVER] [ERROR] Get users endpoint error:', error);
    res.status(500).json({ error: 'Get users error', details: error.message });
  }
});

// gRPC Server-Streaming Endpoint - Subscribe to user updates
app.get('/api/tracker/subscribe-users', (req, res) => {
  try {
    // Check if service is available BEFORE setting SSE headers
    if (!grpcClients.tracker) {
      console.error('[GRPC] [ERROR] Tracker service not available');
      return res.status(503).json({ error: 'Tracker service not available' });
    }

    console.log('[GRPC] Client connected to getUsers stream');

    // Set up Server-Sent Events (SSE) headers for streaming
    res.setHeader('Content-Type', 'text/event-stream');
    res.setHeader('Cache-Control', 'no-cache');
    res.setHeader('Connection', 'keep-alive');
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Transfer-Encoding', 'chunked');
    res.setHeader('X-Accel-Buffering', 'no'); // Disable nginx buffering
    
    // Send initial comment to establish connection
    res.write(':ok\n\n');
    res.flushHeaders(); // Flush headers immediately

    // Call the gRPC streaming method
    const call = grpcClients.tracker.getUsers({});
    
    // Send keepalive comments every 30 seconds to prevent timeout
    const keepaliveInterval = setInterval(() => {
      try {
        res.write(':keepalive\n\n');
        if (res.flush) res.flush();
      } catch (error) {
        clearInterval(keepaliveInterval);
      }
    }, 30000);

    // Handle incoming stream data
    call.on('data', (user) => {
      try {
        console.log('[GRPC] Received data from stream:', JSON.stringify(user));
        // Send each user update as an SSE event
        res.write(`data: ${JSON.stringify(user)}\n\n`);
        // Explicitly flush to ensure data is sent immediately
        if (res.flush) res.flush();
      } catch (error) {
        console.error('[GRPC] [ERROR] Error writing SSE data:', error);
      }
    });

    // Handle stream end
    call.on('end', () => {
      console.log('[GRPC] getUsers stream ended');
      clearInterval(keepaliveInterval);
      res.end();
    });

    // Handle stream errors
    call.on('error', (error) => {
      console.error('[GRPC] [ERROR] getUsers stream error:', error);
      clearInterval(keepaliveInterval);
      try {
        res.write(`event: error\n`);
        res.write(`data: ${JSON.stringify({ error: error.message })}\n\n`);
      } catch (e) {
        // Response may already be closed
      }
      res.end();
    });

    // Handle client disconnect
    req.on('close', () => {
      console.log('[GRPC] Client disconnected from getUsers stream');
      clearInterval(keepaliveInterval);
      call.cancel();
    });

  } catch (error) {
    console.error('[SERVER] [ERROR] Subscribe users endpoint error:', error);
    // Only send JSON if headers haven't been sent yet
    if (!res.headersSent) {
      res.status(500).json({ error: 'Subscribe error', details: error.message });
    } else {
      res.end();
    }
  }
});

// Alternative WebSocket endpoint for real-time streaming (requires WebSocket support)
// This is optional - use if you want native WebSocket instead of SSE
app.post('/api/tracker/subscribe-users-polling', (req, res) => {
  try {
    if (!grpcClients.tracker) {
      return res.status(503).json({ error: 'Tracker service not available' });
    }

    // Fallback polling endpoint - returns current state instead of streaming
    // Useful if client prefers polling over SSE or WebSocket
    const users = [];

    const call = grpcClients.tracker.getUsers({});

    call.on('data', (user) => {
      users.push(user);
    });

    call.on('end', () => {
      res.status(200).json({ users });
      call.cancel();
    });

    call.on('error', (error) => {
      console.error('[GRPC] [ERROR] getUsers polling error:', error);
      res.status(500).json({ error: 'Failed to subscribe', details: error.message });
      call.cancel();
    });

    // Timeout after 30 seconds if no response
    setTimeout(() => {
      if (!res.headersSent) {
        res.status(500).json({ error: 'Subscribe timeout' });
      }
      call.cancel();
    }, 30000);

  } catch (error) {
    console.error('[SERVER] [ERROR] Subscribe polling endpoint error:', error);
    res.status(500).json({ error: 'Subscribe error', details: error.message });
  }
});

// Logs endpoint - receives application logs from the client
app.post('/logs', (req, res) => {
  try {
    const { formattedMessage } = req.body;
    
    // Log to console
    const logEntry = formattedMessage.replace('web-client', `web-client@${req.ip}`);
    
    console.log(`[CLIENT LOG] ${logEntry}`);
    
    res.status(200).json({ success: true, message: 'Log received' });
  } catch (error) {
    console.error('Error processing log:', error);
    res.status(500).json({ success: false, error: 'Failed to process log' });
  }
});

// Serve static files from the Flutter web build
// Configure caching differently for index.html vs other assets
app.use(express.static(path.join(BUILD_DIR), {
  maxAge: 0, // Don't cache by default
  etag: false, // Disable etag to avoid 304 responses
  setHeaders: (res, path, stat) => {
    // Don't cache HTML files (they should always be fresh)
    if (path.endsWith('.html')) {
      res.setHeader('Cache-Control', 'public, max-age=0, must-revalidate');
    }
    // Cache other static assets (JS, CSS, images) for 1 year since they have hashes
    else if (/\.(js|css|png|jpg|jpeg|gif|ico|woff|woff2|ttf|eot|svg)$/i.test(path)) {
      res.setHeader('Cache-Control', 'public, max-age=31536000, immutable');
    }
    // Default: no cache
    else {
      res.setHeader('Cache-Control', 'public, max-age=0, must-revalidate');
    }

    // Ensure CORS headers are applied to static assets too
    res.setHeader('Access-Control-Allow-Origin', '*');
  }
}));

// Send Index.html for client-side routing (SPA fallback)
app.get('/', (req, res) => {
    res.setHeader('Cache-Control', 'public, max-age=0, must-revalidate');
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.sendFile(path.join(BUILD_DIR, 'index.html'));
});

// Fallback for client-side routing - handled by express.static middleware
// Note: express.static already serves the index.html for SPA routing

// Deny all other routes
app.use((req, res) => {
    console.log(`[DEBUG] Catch-all handler: ${req.method} - ${req.originalUrl}`);
    console.log(`[DEBUG] Catch-all handler - Headers:`, req.headers);
    console.log(`[SERVER][ERROR] ${req.method} - ${req.originalUrl}: Requestor IP - ${req.ip}`);

    res.status(404).json({
        error: 'Path not supported',
        path: req.originalUrl,
        method: req.method,
    });
});

// Start server
const httpsOptions = {};
const healthServer = SECURE ? https.createServer(httpsOptions, app) : http.createServer(app);

healthServer.listen(parseInt(PORT), HOST, () => {
  console.log(`
  ═══════════════════════════════════════════════════════════════════════
  Server started successfully!
  ═══════════════════════════════════════════════════════════════════════
  Name: ${NAME}
  Version: ${VERSION}
  Host: ${HOST}
  Port: ${PORT}
  Secure: ${SECURE}

  Available Endpoints:
  ✓ GET  http://${HOST}:${PORT}/health                           (Health check)

  Tracker API Endpoints:
  ✓ POST http://${HOST}:${PORT}/api/tracker/create-user           (Create user)
  ✓ POST http://${HOST}:${PORT}/api/tracker/get-user              (Get user)
  ✓ POST http://${HOST}:${PORT}/api/tracker/move-user             (Move user)
  ✓ POST http://${HOST}:${PORT}/api/tracker/take-trip             (Take trip)
  ✓ POST http://${HOST}:${PORT}/api/tracker/get-users             (Get users - unary)
  ✓ GET  http://${HOST}:${PORT}/api/tracker/subscribe-users       (Subscribe users - streaming SSE)
  ✓ POST http://${HOST}:${PORT}/api/tracker/subscribe-users-polling (Polling fallback)

  gRPC Generic Proxy:
  ✓ POST http://${HOST}:${PORT}/api/grpc/:service/:method        (Generic unary)
  ✓ GET  http://${HOST}:${PORT}/api/grpc/:service/:method/stream  (Generic streaming via SSE)
  ✓ POST http://${HOST}:${PORT}/api/grpc/health/check             (gRPC health check)

  Other:
  ✓ POST http://${HOST}:${PORT}/logs                              (Client logs)

  Configuration:
  ✓ All configuration is baked into the Flutter app at build time via --dart-define

  gRPC Server Connection:
  ✓ Host: ${GRPC_HOST}
  ✓ Port: ${GRPC_PORT}
  ✓ Secure: ${GRPC_SECURE ? 'Yes (TLS)' : 'No (Insecure)'}
  ═══════════════════════════════════════════════════════════════════════
  `);

  // Initialize gRPC clients after server starts
  try {
    initializeGrpcClients();
  } catch (error) {
    console.error('[FATAL] Failed to initialize gRPC clients. Exiting.');
    process.exit(1);
  }
});
