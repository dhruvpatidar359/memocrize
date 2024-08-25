const express = require('express');
const app = express();
const uploadRouter = require("./router/upload-router");

app.use(express.json({ limit: '50mb' })); 


const PORT = 5000;

app.use("/upload",uploadRouter);

app.get("/",(req,res) => {
    res.status(200).send("DHRUV BHADWA HAI");
});


app.listen(PORT,() => {
    console.log("server is running");
});