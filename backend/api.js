import express from "express";

const app = express();
app.use(express.json());

const PORT = 3000;

app.get("/paid-resource", (req, res) => {
  res.status(402).json({
    price: "1000000",
    token: "USDC",
    recipient: "0xcf942c47bc33dB4Fabc1696666058b784F9fa9ef",
    reason: "Payment required to access resource"
  });
});

app.listen(PORT, () => {
  console.log(`Fake API running on http://localhost:${PORT}`);
});
