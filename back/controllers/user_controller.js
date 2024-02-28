const bcrypt = require("bcrypt");
const db = require("../db/db");
const jwt = require("jsonwebtoken");
const nodemailer = require("nodemailer");
const { Op } = require('sequelize');
const User = require('../models/User');
const ResetCode = require('../models/Code');

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.TRANSPORTER_USER,
    pass: process.env.TRANSPORTER_PASS,
  },
});

const authenticate = (req, res, next) => {
  try {
    if (
      req.headers.authorization &&
      req.headers.authorization.split(" ")[0] === "Bearer"
    ) {
      const token = req.headers.authorization?.split(" ")[1];

      if (!token) {
        return res
          .status(401)
          .json({ success: false, message: "Unauthorized" });
      }
      const decoded = jwt.decode(token, process.env.SECRET_KEY);
      req.user = decoded;
      next();
    }
  } catch (err) {
    return res.status(401).json({ success: false, message: "Unauthorized" });
  }
};

const forgotPassword = async (req, res) => {
  try {
    const { email } = req.body;

    const user = await User.findOne({
      where: {
        email: email,
      },
    });
    console.log(email);
    if (!user) {
      res.status(404).json({ success: false, msg: "User not found" });
      return;
    }

    const resetCode = Math.floor(100000 + Math.random() * 900000);
    const timestamp = new Date().getTime();

    await ResetCode.create({
      email: email,
      code: resetCode,
      created_at: timestamp,
    });

    // send email with password reset link
    const mailOptions = {
      from: process.env.TRANSPORTER_USER,
      to: email,
      subject: "Password reset request",
      text: `Your reset code is ${resetCode}. Use this code to reset your password.`,
    };
    await transporter.sendMail(mailOptions);

    res.json({ success: true, msg: "Reset code sent! Check your email!" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, msg: "Internal server error" });
  }
};
const verifyCode = async (req, res) => {
  try {
    const { code } = req.body;
    const resetCode = await ResetCode.findOne({
      where: {
        code: code
      }
    });

    if (resetCode) {
      res.status(200).json({ success: true, msg: "Code verified" });
    } else {
      res.status(400).json({ success: false, msg: "Invalid reset code" });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, msg: "Internal server error" });
  }
};

const resetPassword = async (req, res) => {
  try {
    const { password, code } = req.body;
    const saltRounds = Number(process.env.SALT);
    const hashedPassword = await bcrypt.hash(password, saltRounds);

    const resetCode = await ResetCode.findOne({
      where: {
        code: code,
      },
    });

    if (resetCode) {
      await User.update(
        { password: hashedPassword },
        {
          where: {
            email: resetCode.email,
          },
        }
      );

      await ResetCode.destroy({
        where: {
          code: code,
        },
      });

      res.status(200).json({ success: true, msg: "Password reset successfully" });
    } else {
      res.status(400).json({ success: false, msg: "Invalid reset code" });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, msg: "Internal server error" });
  }
};

const register = async (req, res) => {
  try {
    const { fullname, email, password } = req.body;
    if (!fullname || !email || !password) {
      res.json({ success: false, msg: "Enter all fields" });
    } else {
      // Check if the email already exists
      const existingUser = await User.findOne({ where: { email } });
      if (existingUser) {
        res.json({ success: false, msg: "Email already exists" });
      } else {
        // Hash the password
        const saltRounds = Number(process.env.SALT);
        const hashedPassword = await bcrypt.hash(password, saltRounds);

        // Create a new user
        await User.create({
          fullname,
          email,
          password: hashedPassword,
        });
        res.json({ success: true, msg: "Successfully saved" });
      }
    }
  } catch (error) {
    console.error(error);
    res.status(500).send({ message: "Internal Server Error" });
  }
};
const login = async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      res.json({ success: false, msg: "Enter all fields" });
      return;
    }

    // Find the user by email using the User model
    const user = await User.findOne({ where: { email } });

    if (!user) {
      res.json({ success: false, msg: "Email does not exist" });
      return;
    }

    const isMatch = await bcrypt.compare(password, user.password);

    if (!isMatch) {
      res.json({ success: false, msg: "Invalid credentials" });
      return;
    }

    const token = jwt.sign({ id: user.id }, process.env.SECRET_KEY, {
      expiresIn: "1h",
    });

    res.json({ success: true, token, msg: "Successfully logged in" });
  } catch (error) {
    console.error(error);
    res.status(500).send({ message: "Internal Server Error" });
  }
};

const getUser = async (req, res) => {
  try {
    const id = req.params.id;
    const userId = req.user.id;
    if (userId != id) {
      res.status(401).json({ errorMessage: "Unauthorized" });
    }

    const user = await User.findByPk(userId);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    
    return res.json(user);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error" });
  }
};
const getUsers = async (req, res) => {
  try {

    const userId = req.user.id;
  
    const users = await User.findAll({
      attributes: ['id','fullname'],
      where: {
        id: {
          [Op.ne]: userId
        }
      }
    });
   
    return res.json(users);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error" });
  }
};


const updateUser = async (req, res) => {
  try {
    const { fullname, nickname, email, phone_number, country, gender, address } = req.body;
    const id = req.params.id;
    const userId = req.user.id;

    if (userId != id) {
      res.status(401).json({ message: "Unauthorized" });
    }

    const user = await User.findByPk(userId);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    user.fullname = fullname;
    user.nickname = nickname;
    user.email = email;
    user.phone_number = phone_number;
    user.country = country;
    user.gender = gender;
    user.address = address;

    await user.save();

    res.json({ message: "User updated successfully" });
  } catch (error) {
    console.error(error);
    res.status(500).send({ message: "Internal Server Error" });
  }
};


module.exports = {
  register,
  login,
  forgotPassword,
  verifyCode,
  resetPassword,
  getUser,
  updateUser,
  authenticate,
  getUsers
};
