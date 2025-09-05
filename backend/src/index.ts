import express from 'express';
import cors from 'cors';
import { MongoClient, ObjectId } from 'mongodb';
import dotenv from 'dotenv';

dotenv.config();

const app = express();
app.use(express.json());
app.use(
  cors({
    origin: (origin, cb) => {
      const allowed = (process.env.ALLOWED_ORIGINS || '').split(',');
      if (!origin || allowed.includes(origin)) return cb(null, true);
      return cb(new Error('Not allowed'), false);
    },
  })
);

const client = new MongoClient(process.env.MONGODB_URI!);
let collection = client.db().collection('cards_user');

app.get('/api/cards/user', async (req, res) => {
  const deviceId = req.query.deviceId as string;
  const cards = await collection.find({ deviceId }).toArray();
  res.json(cards);
});

app.post('/api/cards/user', async (req, res) => {
  const card = req.body;
  await collection.insertOne(card);
  res.status(201).end();
});

app.patch('/api/cards/user/:id', async (req, res) => {
  const id = req.params.id;
  const card = req.body;
  const existing = await collection.findOne({ _id: new ObjectId(id) });
  if (!existing || existing.deviceId != card.deviceId) return res.status(403).end();
  await collection.updateOne({ _id: new ObjectId(id) }, { $set: card });
  res.end();
});

app.delete('/api/cards/user/:id', async (req, res) => {
  const id = req.params.id;
  const deviceId = req.body.deviceId;
  const existing = await collection.findOne({ _id: new ObjectId(id) });
  if (!existing || existing.deviceId != deviceId) return res.status(403).end();
  await collection.deleteOne({ _id: new ObjectId(id) });
  res.end();
});

const port = process.env.PORT || 3000;
client.connect().then(() => {
  app.listen(port, () => console.log(`server on ${port}`));
});
