'use strict';

const express = require('express');
const fs = require('fs');
const fsx = require('fs-extra');
const crypto = require('crypto');
const axios = require('axios');
const execa = require('execa')

const PORT = 8080;
const HOST = '0.0.0.0';
const TMP_PATH = '/tmp/images'
const CUBE_PREFIX = 'pano-';
const CUBE_SUFFIXES = ['l', 'r', 'b', 'f', 'u', 'd'];

const app = express();
app.get('/', async (req, res) => {
    try {
        const {baseUrl} = req.query;
        const hashName = makeHash(baseUrl);
        const saveDir = `${TMP_PATH}/${hashName}`

        await mkdir(saveDir)
        await Promise.all(CUBE_SUFFIXES.map((suffix) => {
            const filePath = `${saveDir}/${suffix}.jpg`
            return downloadImage(`${baseUrl}/${CUBE_PREFIX}${suffix}.jpg`, filePath)
        }))
        await makeSphere(saveDir, 'sphere.jpg')

        const data = fs.readFileSync(`${saveDir}/sphere.jpg`);
        fsx.removeSync(saveDir);
        res.type('jpg');
        res.send(data);
    } catch (err) {
        res.send(err)
    }
});

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);

const downloadImage = async (url, path) => {
    const {data} = await axios.get(url, {responseType: "arraybuffer"});
    fs.writeFileSync(path, new Buffer.from(data), 'binary');
}

const mkdir = async (path) => {
    if (!fs.existsSync(path)) {
        fs.mkdirSync(path);
    }
}

const makeHash = (plainText) => {
    return crypto.createHash('md5').update(plainText).digest('hex')
}

const makeSphere = async (saveDir, sphereName) => {
    const {stdout} = await execa('bash', [
        '-c',
        [
            'krpanotools',
            'cube2sphere',
            ...CUBE_SUFFIXES.map((suffix) => `-${suffix}="${saveDir}/${suffix}.jpg"`),
            `-o="${saveDir}/${sphereName}"`
        ].join(' ')
    ]);
}

