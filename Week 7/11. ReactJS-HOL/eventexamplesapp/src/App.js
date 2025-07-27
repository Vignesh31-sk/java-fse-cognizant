import React, { useState } from 'react';
import CurrencyConvertor from './CurrencyConvertor';

function App() {
  const [count, setCount] = useState(0);

  const sayHello = () => {
    console.log("Hello! This is a static message.");
  };

  const increment = () => {
    setCount(count + 1);
    sayHello();
  };

  const decrement = () => {
    setCount(count - 1);
  };

  const sayMessage = (msg) => {
    alert(msg);
  };

  const handleSyntheticEvent = (event) => {
    alert("I was clicked");
    console.log(event); // This is a SyntheticEvent
  };

  return (
    <div className="App">
      <h1>Event Examples</h1>

      <h2>Counter: {count}</h2>
      <button onClick={increment}>Increment</button>
      <button onClick={decrement}>Decrement</button>

      <br /><br />
      <button onClick={() => sayMessage("Welcome!")}>Say Welcome</button>

      <br /><br />
      <button onClick={handleSyntheticEvent}>OnPress</button>

      <br /><br />
      <CurrencyConvertor />
    </div>
  );
}

export default App;
