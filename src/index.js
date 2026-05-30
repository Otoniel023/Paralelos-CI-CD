require('dotenv').config();
const express = require('express');
const { apiReference } = require('@scalar/express-api-reference');
const swaggerSpec = require('./config/swagger');
const userRoutes = require('./interfaces/http/routes/userRoutes');

const app = express();

app.use(express.json());

app.get('/health', (_, res) => res.json({ status: 'ok', proyecto: 'Calzado API' }));

app.get('/openapi.json', (_, res) => res.json(swaggerSpec));

app.use('/docs', apiReference({ url: '/openapi.json', theme: 'purple' }));

app.use('/api/usuarios', userRoutes);

app.use((req, res) => res.status(404).json({ error: 'Ruta no encontrada' }));

app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Error interno del servidor' });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Calzado API corriendo en http://localhost:${PORT}`);
});
