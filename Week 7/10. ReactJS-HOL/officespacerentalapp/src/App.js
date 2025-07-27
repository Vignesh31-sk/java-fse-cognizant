import React from 'react';
import './App.css';

function App() {
  const officeList = [
  {
    name: "Regus Office",
    rent: 45000,
    address: "MG Road, Bangalore",
    image: "https://plus.unsplash.com/premium_photo-1661938316795-02d427070b15?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
  },
  {
    name: "WeWork Space",
    rent: 65000,
    address: "Cyber Hub, Gurgaon",
    image: "https://images.unsplash.com/photo-1497366811353-6870744d04b2?q=80&w=2069&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
  },
  {
    name: "IndiQube",
    rent: 55000,
    address: "Kondapur, Hyderabad",
    image: "https://plus.unsplash.com/premium_photo-1670315264879-59cc6b15db5f?q=80&w=1171&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
  }
];


  return (
    <div className="App">
      <h1>🏢 Office Space Rental</h1>
      <img src="https://via.placeholder.com/600x200" alt="Office Banner" />

      {officeList.map((office, index) => (
        <div key={index} style={{ border: "1px solid #ccc", margin: "10px", padding: "10px" }}>
          <h2>{office.name}</h2>
          <img src={office.image} alt={office.name} className="office-img" />
          <p><strong>Address:</strong> {office.address}</p>
          <p style={{ color: office.rent < 60000 ? 'red' : 'green' }}>
            <strong>Rent:</strong> ₹{office.rent}
          </p>
        </div>
      ))}
    </div>
  );
}

export default App;
