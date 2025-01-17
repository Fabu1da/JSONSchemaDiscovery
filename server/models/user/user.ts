import * as bcrypt from 'bcryptjs';
import * as mongoose from 'mongoose';

interface IUser extends mongoose.Document {
  username: string;
  email: string;
  password: string;
  comparePassword: (candidatePassword: string) => Promise<boolean>;
}

const userSchema = new mongoose.Schema({
  'username': {type: String, required: true},
  'email': {type: String, unique: true, lowercase: true, trim: true, required: true},
  'password': {type: String, required: true}
}, {timestamps: {createdAt: 'createdAt'}});

userSchema.methods.comparePassword = function (
  this: IUser,
  candidatePassword: string
): Promise<boolean> {
  return bcrypt.compare(candidatePassword, this.password);
};

userSchema.set('toJSON', {
  transform: function (doc, ret, options) {
    delete ret.password;
    return ret;
  }
});

export default mongoose.model<IUser>('User', userSchema);
