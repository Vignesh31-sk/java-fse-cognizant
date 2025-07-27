import React from 'react';
import CohortDetails from './CohortDetails';

function App() {
  const cohorts = [
    {
      name: 'React Bootcamp',
      status: 'ongoing',
      startDate: '2024-07-01',
      endDate: '2024-09-30'
    },
    {
      name: 'Data Science 101',
      status: 'completed',
      startDate: '2024-01-15',
      endDate: '2024-04-15'
    }
  ];

  return (
    <div>
      <h1>My Academy Dashboard</h1>
      {cohorts.map((cohort, index) => (
        <CohortDetails key={index} cohort={cohort} />
      ))}
    </div>
  );
}

export default App;