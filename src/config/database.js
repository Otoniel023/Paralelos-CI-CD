const { Pool } = require('pg');
require('dotenv').config();

const isProduction = process.env.NODE_ENV === 'production';

const poolConfig = {
  user:     process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  max: 10,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
};

if (isProduction && process.env.DB_SOCKET_PATH) {
  // GCP Cloud SQL - conexion por socket Unix
  poolConfig.host = process.env.DB_SOCKET_PATH;
} else {
  // Local - conexion normal
  poolConfig.host = process.env.DB_HOST || 'localhost';
  poolConfig.port = process.env.DB_PORT || 5432;
}

const pool = new Pool(poolConfig);

pool.on('error', (err) => {
  console.error('Error en el pool de PostgreSQL:', err);
});

// Wrapper para mantener la misma interfaz que mysql2
// Tu codigo usa pool.query() igual que antes
module.exports = {
  query: (text, params) => pool.query(text, params),
  pool,
};
