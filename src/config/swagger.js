const swaggerJsdoc = require('swagger-jsdoc');

const options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'Calzado API',
      version: '1.0.0',
      description: 'API REST para sistema de calzado con autenticación JWT y CRUD de usuarios',
    },
    servers: [{ url: 'http://localhost:3000' }],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT',
        },
      },
      schemas: {
        Usuario: {
          type: 'object',
          properties: {
            id:       { type: 'integer', example: 1 },
            nombre:   { type: 'string',  example: 'Juan Pérez' },
            email:    { type: 'string',  example: 'juan@ejemplo.com' },
            rol:      { type: 'string',  enum: ['admin', 'usuario'], example: 'usuario' },
          },
        },
        UsuarioInput: {
          type: 'object',
          required: ['nombre', 'email', 'password'],
          properties: {
            nombre:   { type: 'string',  example: 'Juan Pérez' },
            email:    { type: 'string',  example: 'juan@ejemplo.com' },
            password: { type: 'string',  example: 'secreto123' },
            rol:      { type: 'string',  enum: ['admin', 'usuario'], example: 'usuario' },
          },
        },
        LoginInput: {
          type: 'object',
          required: ['email', 'password'],
          properties: {
            email:    { type: 'string', example: 'admin@ejemplo.com' },
            password: { type: 'string', example: 'secreto123' },
          },
        },
        LoginResponse: {
          type: 'object',
          properties: {
            token: { type: 'string', example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...' },
          },
        },
        Error: {
          type: 'object',
          properties: {
            error: { type: 'string', example: 'Mensaje de error' },
          },
        },
      },
    },
  },
  apis: ['./src/interfaces/http/routes/*.js'],
};

module.exports = swaggerJsdoc(options);
