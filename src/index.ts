
import express, { type Express } from 'express';
import dotenv from 'dotenv';

dotenv.config();

const app: Express = express();
const port = process.env.PORT || 3004;

app.use(express.json());

app.get('/quote', (req, res) => {
    const productId = req.query.productId as string;

    if (!productId) {
        return res.status(400).json({ message: 'productId is required' });
    }

    const pseudoRandom = productId.split('').reduce((acc, char) => acc + char.charCodeAt(0), 0);
    const quotePrice = parseFloat(((pseudoRandom % 100) + 50).toFixed(2));

    res.status(200).json({
        productId,
        quotePrice,
        provider: 'Azure Function Simulator',
        validUntil: new Date(Date.now() + 24 * 60 * 60 * 1000),
    });
});

app.listen(port, () => {
    console.log(`Quote Function Simulator running at http://localhost:${port}`);
});
