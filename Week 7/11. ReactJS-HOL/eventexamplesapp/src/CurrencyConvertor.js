import React, { useState } from 'react';

const CurrencyConvertor = () => {
  const [rupees, setRupees] = useState("");
  const [euro, setEuro] = useState("");

  const handleSubmit = () => {
    if (!rupees || isNaN(rupees)) {
      alert("Please enter a valid number.");
      return;
    }
    const conversionRate = 0.011; // Example rate: 1 INR = 0.011 Euro
    setEuro((rupees * conversionRate).toFixed(2));
  };

  return (
    <div>
      <h2>Currency Convertor</h2>
      <input
        type="number"
        placeholder="Enter amount in INR"
        value={rupees}
        onChange={(e) => setRupees(e.target.value)}
      />
      <button onClick={handleSubmit}>Convert</button>
      {euro && <p>Euro: €{euro}</p>}
    </div>
  );
};

export default CurrencyConvertor;
