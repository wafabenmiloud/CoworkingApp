const express = require("express");
const router = express.Router();


const { register, login, resetPassword, forgotPassword, verifyCode, authenticate, getUser, updateUser,getUsers } = require("./controllers/user_controller");
const { addIgloo, getIgloos, getIglooById, likeDislike } = require("./controllers/igloo_controller");
const { getMessagesByChatID} = require("./controllers/chat_controller");

//user api
router.post("/register", register);
router.post("/login", login);
router.post("/forgetpass", forgotPassword);
router.post("/verifycode", verifyCode);
router.post("/resetpass", resetPassword);
router.get("/user/:id", authenticate, getUser);
router.put("/user/:id", authenticate, updateUser);
router.get("/users", authenticate ,getUsers);

//igloo api
router.post("/addigloo", authenticate, addIgloo);
router.get("/getigloos", getIgloos);
router.get("/getigloos/:id", getIglooById);
router.post("/igloos/like/:id", authenticate, likeDislike);

//chat api
router.get("/getmsg/:chatID", getMessagesByChatID);

module.exports = router;
