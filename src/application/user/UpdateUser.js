const bcrypt = require('bcryptjs');

class UpdateUser {
  constructor(userRepository) {
    this.userRepository = userRepository;
  }

  async execute(id, { nombre, apellido, email, password, rol }) {
    const existing = await this.userRepository.findById(id);
    if (!existing) throw new Error('Usuario no encontrado');

    const data = { nombre, apellido, email, rol };

    if (password) {
      data.password = await bcrypt.hash(password, 10);
    }

    const updated = await this.userRepository.update(id, data);
    return updated.toPublic();
  }
}

module.exports = UpdateUser;
