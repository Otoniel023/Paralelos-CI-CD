require('dotenv').config();
const express = require('express');
const path = require('path');
const fs = require('fs');
const swaggerUi   = require('swagger-ui-express');
const swaggerSpec  = require('./config/swagger');
const userRoutes = require('./interfaces/http/routes/userRoutes');
const uploadRoutes = require('./interfaces/http/routes/uploadRoutes');

const app = express();

const uploadsDir = path.join(process.cwd(), 'uploads');
if (!fs.existsSync(uploadsDir)) fs.mkdirSync(uploadsDir, { recursive: true });

app.use(express.json());
app.use('/uploads', express.static(uploadsDir));

app.get('/health', (_, res) => res.json({ status: 'ok', proyecto: 'Calzado API' }));

app.get('/openapi.json', (_, res) => res.json(swaggerSpec));

app.use('/docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));

app.use('/api/usuarios', userRoutes);
app.use('/api/upload', uploadRoutes);

app.use((req, res) => res.status(404).json({ error: 'Ruta no encontrada' }));

app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Error interno del servidor' });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Calzado API corriendo en http://localhost:${PORT}`);
});
