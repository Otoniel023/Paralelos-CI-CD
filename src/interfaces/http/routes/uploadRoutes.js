const { Router } = require('express');
const { authMiddleware } = require('../middlewares/authMiddleware');
const upload = require('../middlewares/uploadMiddleware');

const router = Router();

/**
 * @openapi
 * /api/upload:
 *   post:
 *     tags: [Upload]
 *     summary: Subir un archivo (imagen o PDF)
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             required: [file]
 *             properties:
 *               file:
 *                 type: string
 *                 format: binary
 *                 description: Archivo a subir (jpeg, png, gif, webp, pdf — máx 5MB)
 *     responses:
 *       200:
 *         description: Archivo subido exitosamente
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/UploadResponse'
 *       400:
 *         description: No se envió ningún archivo o tipo no permitido
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       401:
 *         description: No autorizado
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 */
router.post(
  '/',
  authMiddleware,
  (req, res, next) => {
    upload.single('file')(req, res, (err) => {
      if (err) return res.status(400).json({ error: err.message });
      next();
    });
  },
  (req, res) => {
    if (!req.file) return res.status(400).json({ error: 'No se envió ningún archivo' });

    const BASE_URL = process.env.BASE_URL || `http://localhost:${process.env.PORT || 3000}`;

    res.json({
      message: 'Archivo subido exitosamente',
      filename: req.file.filename,
      originalname: req.file.originalname,
      mimetype: req.file.mimetype,
      size: req.file.size,
      url: `${BASE_URL}/uploads/${req.file.filename}`,
    });
  }
);

module.exports = router;
