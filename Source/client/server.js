const express = require('express');
const path = require('path');
const fs = require('fs');
const http = require('http');
const https = require('https');

const app = express();
const PORT = process.env.APP_PORT || 8080;
const HOST = process.env.APP_HOST || '0.0.0.0';
const NAME = process.env.APP_NAME || 'flutter-web-client';
const VERSION = process.env.APP_VERSION || '0.0.1';
const BUILD_DIR = path.join(__dirname, 'build/web');
const SECURE = process.env.SERVER_SECURE === 'true';

// Middleware to parse JSON bodies
app.use(express.json());

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
app.use(express.static(path.join(BUILD_DIR)));

// Send Index.html
app.get('/', (req, res) => {
    res.sendFile(path.join(BUILD_DIR, 'index.html'));
});

// Deny all other routes
app.use((req, res) => {
    console.log(`[SERVER][ERROR] ${req.method} - ${req.originalUrl}: Requestor IP - ${req.ip}`);

    res.status(404).json({
        error: 'Path not supported',
        path: req.originalUrl,
        method: req.method,
    });
});

// TODO: Add HTTPS options if needed
  const httpsOptions = {};

  const healthServer = SECURE ? https.createServer(httpsOptions, app) : http.createServer(app);

  healthServer.listen(parseInt(PORT), HOST, () => {
    console.log(`Server is running on port ${PORT}`);
    console.log(`Health check available at http://${HOST}:${PORT}/health`);
    console.log(`Logs endpoint available at http://${HOST}:${PORT}/logs`);
  });
