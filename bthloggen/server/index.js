const express = require("express");
const app = express();
const port = 1338;

app.get("/", (req, res) => {
    const routes = {
        "routes": {
            0: "/ - Presentation of supported routes",
            1: "/data - Show all rows",
            2: "/data/ip/:ip - Show rows matching <ip>",
            3: "/data/url/:url - Show row matching <url>"
        }
    };

    res.json(routes);
});

app.get("/data", (req, res) => {
    const itemsfile = require('../data/log.json');

    res.json(itemsfile);
});

app.get("/data/ip/:ip", (req, res) => {
    const itemsfile = require('../data/log.json');
    let ip = req.params.ip;
    let result = itemsfile.filter(item => item.ip.includes(ip));

    res.json(result);
});

app.get("/data/url/:url", (req, res) => {
    const itemsfile = require('../data/log.json');
    let url = req.params.url;
    let result = itemsfile.filter(item => item.url.includes(url));

    res.json(result);
});

app.listen(port, () => console.log(`Example app listening on port ${port}!`));
