var express = require('express');
var app = express();


const bodyParser = require('body-parser');
const hdWallet = require('tron-wallet-hd');
var router = express.Router();
const TronWeb = require('tronweb');
var fullNode = 'https://api.shasta.trongrid.io';
var solidityNode = 'https://api.shasta.trongrid.io';
var eventServer = 'https://api.shasta.trongrid.io';
const tronWeb = new TronWeb({
    fullNode: 'https://api.shasta.trongrid.io',
    solidityNode: 'https://api.shasta.trongrid.io',
    eventServer: 'https://api.shasta.trongrid.io'
}
)

const MongoClient = require('mongodb').MongoClient;
const uri = "mongodb+srv://yazidly:Mister223@cluster0.oqdjq.mongodb.net/TronWallet?retryWrites=true&w=majority";
const client = new MongoClient(uri, { useNewUrlParser: true, useUnifiedTopology: true });



client.connect(err => {
    const collection = client.db("TronWallet").collection("addressTable");
    // perform actions on the collection object
    app.use(express.json());
    app.use(bodyParser.urlencoded({ extended: true }));
    app.post("/createNewone", async (req, res) => {
        var number = req.body.number
        const seed = hdWallet.generateMnemonic();

        const account = await hdWallet.generateAccountsWithMnemonic(seed, number);



        collection.insertMany([{ seed, account }])
            .then(result => {
                console.log(result)
            })
            .catch(error => console.error(error))
        res.json({
            seed,
            account
        })

    });


    app.post('/balance', async function (req, res, next) {
        //userBalance();
        var address = req.body.address
        const balance = await tronWeb.trx.getBalance(address);
        const getUserBalance = tronWeb.toSun(balance / Math.pow(10, 12));
        res.json({
            getUserBalance
        })
    });


    app.post('/balanceUSDT', async (req, res) => {
        var privateKey = req.body.privateKey
        var fromAddress = req.body.fromAddress
        //change the contract with the mainnet contract
        const CONTRACT = "TCRFdzo2DhXV8DGdX8KHpakCvVXAjcdR2B"

        const tronUSDT = new TronWeb(fullNode, solidityNode, eventServer, privateKey)
        const { abi } = await tronUSDT.trx.getContract(CONTRACT)
        const contract = tronUSDT.contract(abi.entrys, CONTRACT)
        const balance = await contract.methods.balanceOf(fromAddress).call();
        const BALANCE = tronUSDT.fromSun(balance / Math.pow(10, 18));

        res.json({
            
            BALANCE
        })


    })

    app.post("/createWithExistingMnemonice", async (req, res) => {
        var number = req.body.number
        seed = req.body.seed

        const account = await hdWallet.generateAccountsWithMnemonic(seed, number);



        collection.insertMany([{ seed, account }])
            .then(result => {
                console.log(result)
            })
            .catch(error => console.error(error))
        res.json({
            seed,
            account

        })

    })




    app.post('/sendTron', async (req, res) => {
        var privateKey = req.body.privateKey
        var fromAddress = req.body.fromAddress
        var toAddress = req.body.toAddress
        var amount = req.body.amount

        tradeobj = await tronWeb.transactionBuilder.sendTrx(
            toAddress,
            amount,
            fromAddress
        );
        const signedtxn = await tronWeb.trx.sign(
            tradeobj,
            privateKey
        );
        const receipt = await tronWeb.trx.sendRawTransaction(
            signedtxn
        );
        res.json({
            tradeobj,
            fromAddress,
            toAddress,
            amount
        })
    })



    app.post('/sendUSDT', async (req, res) => {
        var privateKey = req.body.privateKey
        var toAddress = req.body.toAddress
        var amount = req.body.amount
        var fromAddress = req.body.fromAddress

        //change the contract with the mainnet contract
        const CONTRACT = "TCRFdzo2DhXV8DGdX8KHpakCvVXAjcdR2B"

        const tronUSDT = new TronWeb(fullNode, solidityNode, eventServer, privateKey)
        const { abi } = await tronUSDT.trx.getContract(CONTRACT)
        const contract = tronUSDT.contract(abi.entrys, CONTRACT)

        const send = await contract.methods.transfer(toAddress, amount).send();

        res.json({

            send

        })


    })


    app.get('/list', (req, res) => {

        collection.find().toArray()

            .then(results => {
                console.log(results)
                res.send({ "results": results })
            })
            .catch(error => console.error(error))


    })

    app.get('/addressDetail', (req, res) => {
        var id = new require('mongodb').ObjectID(req.body.id);
        var address = req.body.address;
        collection.findOne({ "$or": [{ '_id': id }, { "address": address }] })
            .then(async function (doc) {
                seed = doc.seed;
                const accountA = await hdWallet.getAccountAtIndex(seed, 0);
                if (!doc)
                    throw new Error('No record found.');

                console.log(accountA);//else case
                res.send({ "results": accountA })
            });

    })


    app.listen(3000, () => {
        console.log("server is running fine");
    });


});











