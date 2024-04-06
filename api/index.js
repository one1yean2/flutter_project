const express = require('express');
const jwt = require('jsonwebtoken');
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());

const secret = 'TypicalSecret';
const Users =
    [
        {
            id: 1,
            username: 'test',
            password: 'test',
            displayName: 'NongYean',
            scores: [

            ],
        }

    ];


app.get('/', function (req, res) {
    res.send('Nothing to see here!');
});


app.post('/login', function (req, res) {
    const { username, password } = req.body;
    if (!username || !password) {
        res.status(200).send({error:"Username and password are required"});
        return;
    }

    const user = Users.find(
        (user) => user.username === username && user.password === password
    );
    if (user) {
        var token = jwt.sign(
            {
                id: user.id,
            },
            secret
        );
        res.status(200).send({
            token :token,
            user: {
                displayName: user.displayName,
            },
        });
    } else {
        res.status(200).send({error:"Not Found"});
    }
});

function verifyToken(req, res) {
    const token = req.headers.authorization?.split(" ")[1];
    if (!token) {
        res.status(401).send("Unauthorized");
        return null;
    }

    try {
        const decoded = jwt.verify(token, secret);
        const user = Users.find((user) => user.id === decoded.id);
        if (!user) {
            res.status(404).send("Not found");
            return null;
        }
        return user;
    } catch (e) {
        res.status(401).send(e.message);
        return null;
    }
}

app.get('/score', function (req, res) {
    // const user = verifyToken(req, res);
    // if (!user) {
    //     return;
    // }
    // res.status(200).send({ 
    //     displayName : Users[0].displayName,
    //     score: Users[0].scores });
    res.status(200).send(Users);
});

app.post('/score', function (req, res) {
    const user = verifyToken(req, res);
    if (!user) {
        return;
    }
    const { id, score, time ,typedText,colorText} = req.body;
    user.scores.push({ id, score, time,typedText,colorText});
    res.status(200).send('{ score: user.scores }');
});
app.post('/register', function (req, res) {
    const { username, password, displayName } = req.body;
    if (!username || !password || !displayName) {
        res.status(200).send({error:"Username, password and display name are required"});
        return;
    }
    const user = Users.find((user) => user.username === username);
    if (user) {
        res.status(200).send({error:"Username already exists"});
        return;
    }
    const newUser = {
        id: Users.length + 1,
        username,
        password,
        displayName,
        scores: [],
    };
    Users.push(newUser);
    res.status(201).send(newUser);
})

app.listen(3000);