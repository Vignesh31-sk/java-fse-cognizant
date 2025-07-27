import React, { useState } from 'react';
import GuestPage from './components/GuestPage';
import UserPage from './components/UserPage';

function App() {
  const [isLoggedIn, setIsLoggedIn] = useState(false);

  const handleToggleLogin = () => {
    setIsLoggedIn(prev => !prev);
  };

  let displayComponent;
  if (isLoggedIn) {
    displayComponent = <UserPage />;
  } else {
    displayComponent = <GuestPage />;
  }

  return (
    <div className="App">
      <h1>✈️ Ticket Booking App</h1>
      <button onClick={handleToggleLogin}>
        {isLoggedIn ? 'Logout' : 'Login'}
      </button>
      {displayComponent}
    </div>
  );
}

export default App;
