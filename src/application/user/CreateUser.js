const bcrypt = require('bcryptjs');

class CreateUser {
  constructor(userRepository) {
    this.userRepository = userRepository;
  }

  async execute({ nombre, apellido, email, password, rol }) {
    const existing = await this.userRepository.findByEmail(email);
    if (existing) throw new Error('El email ya está registrado');

    const hashed = await bcrypt.hash(password, 10);
    const user = await this.userRepository.create({ nombre, apellido, email, password: hashed, rol });
    return user.toPublic();
  }
}

module.exports = CreateUser;
