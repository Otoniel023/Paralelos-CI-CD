/**
 * Interfaz del repositorio de usuarios.
 * Principio D (Inversión de Dependencias): los casos de uso dependen
 * de esta abstracción, no de la implementación concreta de MySQL.
 */
class IUserRepository {
  async findAll() { throw new Error('Not implemented'); }
  async findById(id) { throw new Error('Not implemented'); }
  async findByEmail(email) { throw new Error('Not implemented'); }
  async create(userData) { throw new Error('Not implemented'); }
  async update(id, userData) { throw new Error('Not implemented'); }
  async delete(id) { throw new Error('Not implemented'); }
}

module.exports = IUserRepository;
