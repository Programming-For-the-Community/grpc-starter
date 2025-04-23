import parser from '@typescript-eslint/parser';
import typescriptEslint from '@typescript-eslint/eslint-plugin'; // Use default import here
import prettierPlugin from 'eslint-plugin-prettier';

export default [
  {
    files: ['**/*.ts', '**/*.tsx'],
    languageOptions: {
      parser,
      parserOptions: {
        ecmaVersion: 2020,
        sourceType: 'module',
        project: './tsconfig.json',
      },
    },
    plugins: {
      '@typescript-eslint': typescriptEslint,
      prettier: prettierPlugin,
    },
    rules: {
      'no-console': 'warn',
      'no-process-exit': 'error',
      indent: ['error', 2],
      quotes: ['error', 'single'],
      semi: ['error', 'always'],
      'no-undef': 'warn',
      'no-path-concat': 'warn',
      'prefer-const': 'error',
      'no-unused-vars': 'error',
      'prettier/prettier': 'warn',
    },
    settings: {},
  },
  {
    ignores: [
      '**/node_modules/**',
      '**/dist/**',
      '**/proto/**',
      '**/protoDefinitions/**',
      '**/__tests__/**',
    ]
  }
];
