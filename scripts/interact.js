const ethers = require("ethers");
require("dotenv").config();
const ALCHEMY_API = process.env.ALCHEMY_API;
const API_KEY = process.env.API_KEY;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const contractAddress = process.env.CONTRACT_ADDRESS;

const provider = new ethers.AlchemyProvider("goerli", API_KEY);
const signer = new ethers.Wallet(PRIVATE_KEY, provider);
const {
  abi,
} = require("../artifacts/contracts/MedicalRecord.sol/MedicalRecord.json");
const contractInstance = new ethers.Contract(contractAddress, abi, signer);

const express = require("express");
const app = express();
app.use(express.json());

app.get("/records/:id", async (req, res) => {
  //http://localhost:3000/products/1
  try {
    const id = req.params.id;
    const record = await contractInstance.getRecordsbyDoctorId(id);
    console.log(record);
    let r = [];
    r[0] = parseInt(record[0]);
    r[1] = record[1];
    r[2] = record[2];
    res.send(r);
  } catch (error) {
    res.status(500).send(error.message);
  }
});

app.get("/records/", async (req, res) => {
  //http://localhost:3000/products/
  try {
    const records = await contractInstance.getAll();
    const data = records.map((record) => ({
      id: parseInt(record.id),
      data: record.data,
      userId: record.userId,
      doctorId: record.userId,
    }));
    console.log(data);
    res.send(data);
  } catch (error) {
    res.status(500).send(error.message);
  }
});

app.post("/records", async (req, res) => {
  try {
    const tx = await contractInstance.createMedicalRecord(
      JSON.stringify(data),
      "u1",
      "d1"
    );
    await tx.wait();
    res.json({ success: true });
  } catch (error) {
    res.status(500).send(error.message);
  }
});

app.put("/products/:id", async (req, res) => {
  //http://localhost:3000/products/1
  try {
    const id = req.params.id;
    const { name, price, quantity } = req.body;
    const tx = await contractInstance.updateProduct(id, name, price, quantity);
    await tx.wait();
    res.json({ success: true });
  } catch (error) {
    res.status(500).send(error.message);
  }
});

app.delete("/products/:id", async (req, res) => {
  try {
    const id = req.params.id;
    const tx = await contractInstance.deleteProduct(id);
    await tx.wait();
    res.json({ success: true });
  } catch (error) {
    res.status(500).send(error.message);
  }
});

const port = 3000;
app.listen(port, () => {
  console.log("API server is listening on port 3000");
});

let data = {
  fullName: "Thang",
  birthday: "10/05/2000",
  gender: "Nam",
  jog: "Student",
  location: "DN",
  phone: "0333333333",
  idNumber: "socancuoc",
  dayIn: "19/12/2022",
  medicalHistory: "Bệnh sử, ... xyz",
  reason: "Lý do khám bệnh: ...xyz",
  status: "Thể trạng trước khi khám: ...xyz",
  diagnostic: "Chuẩn đoán bệnh: bị abc ... xyz",
  treatment: "Phương pháp điều trị: ...xyz",
  userId: "thang1",
  doctorId: "doctor1",
};
