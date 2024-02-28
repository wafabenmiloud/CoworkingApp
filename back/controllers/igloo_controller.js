const multer = require("multer");
const moment = require('moment');
const Igloo = require ('../models/Igloo')
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/');
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
    const extension = file.originalname.split('.').pop();
    const fileName = file.fieldname + '-' + uniqueSuffix + '.' + extension;
    cb(null, fileName);
  },
});

const upload = multer({
  storage: storage,
}).fields([
  { name: 'images', maxCount: 10 },
  { name: 'files', maxCount: 10 },
]);

const addIgloo = async (req, res) => {
  try {
    await upload(req, res, function (err) {
      if (err instanceof multer.MulterError) {
        console.log(err);
        return res.status(422).send("Error uploading images");
      } else if (err) {
        console.log(err);
        return res.status(500).send('Internal server error');
      }

      const userId = req.user.id;
      const {
        igloo_name,
        igloo_type,
        coworking_place,
        internet,
        days,
        transport,
        equipements,
        description,
        startDate,
        endDate,
        startTime,
        endTime,
        animals,
        accept_animals,
        habitude,
        fauteil,
        ascenseur,
        cuisine,
        ville,
        location,
        price,
        nb_places,
        lat,
        long
      } = req.body;

      const images = req.files.images ? req.files.images.map((file) => file.path) : [];
      const files = req.files.files ? req.files.files.map((file) => file.path) : [];

      const coworking_placeArray = Array.isArray(coworking_place) ? coworking_place : [coworking_place];
      const internetArray = Array.isArray(internet) ? internet : [internet];
      const transportArray = Array.isArray(transport) ? transport : [transport];
      const equipementsArray = Array.isArray(equipements) ? equipements : [equipements];
      const animalsArray = Array.isArray(animals) ? animals : [animals];
      const daysArray = Array.isArray(days) ? days : [days];
      const startDateObj = moment(startDate, 'DD MMM YYYY', 'fr').toDate();
      const endDateObj = moment(endDate, 'DD MMM YYYY', 'fr').toDate();

      // Create a new instance of the Igloo model
      Igloo.create({
        igloo_name,
        igloo_type,
        coworking_place: JSON.stringify(coworking_placeArray),
        internet: JSON.stringify(internetArray),
        days: JSON.stringify(daysArray),
        transport: JSON.stringify(transportArray),
        equipements: JSON.stringify(equipementsArray),
        description,
        startDate: startDateObj,
        endDate: endDateObj,
        start_time: startTime,
        end_time: endTime,
        animals: JSON.stringify(animalsArray),
        accept_animals: accept_animals,
        habitude,
        fauteil,
        ascenseur,
        cuisine,
        ville,
        location,
        price,
        nb_places,
        user_id: userId,
        images: JSON.stringify(images),
        files:JSON.stringify(files),
        latitude: lat,
        longitude: long
      });

      return res.status(200).json({ success: true, msg: "Igloo added successfully" });
    });
  } catch (error) {
    console.error(error);
    return res.status(401).json({ errorMessage: "Unauthorized" });
  }
};

const getIgloos = async (req, res) => {
  try {
    const igloos = await Igloo.findAll();
    res.status(200).json(igloos);
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, msg: "Internal server error" });
  }
};

const getIglooById = async (req, res) => {
  try {
    const id = req.params.id;
    const igloo = await Igloo.findByPk(id);
    res.status(200).json(igloo);
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, msg: "Internal server error" });
  }
};
const likeDislike = async (req, res) => {
  try {
    const userId = req.user.id;

    const id = req.params.id;
    const igloo = await Igloo.findByPk(id);
    if (userId !== igloo.user_id) {
      return res.status(403).json({ success: false, msg: 'Unauthorized' });
    }
    
    igloo.liked = !igloo.liked;
    await igloo.save();

    res.status(200).json({ success: true, msg: 'Igloo liked/disliked successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, msg: 'Internal server error' });
  }
};
module.exports = {
  addIgloo,
  getIgloos,
  getIglooById,likeDislike
};
