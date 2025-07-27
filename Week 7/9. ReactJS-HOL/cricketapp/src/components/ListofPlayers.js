const players = [
  { name: 'Virat', score: 80 },
  { name: 'Rohit', score: 60 },
  { name: 'Rahul', score: 75 },
  { name: 'Gill', score: 50 },
  { name: 'Jadeja', score: 90 },
  { name: 'Bumrah', score: 40 },
  { name: 'Pant', score: 65 },
  { name: 'Ashwin', score: 85 },
  { name: 'Surya', score: 70 },
  { name: 'Shami', score: 55 },
  { name: 'Kohli', score: 95 }
];

const ListofPlayers = () => {
  const filtered = players.filter(p => p.score < 70);
  
  return (
    <div>
      <h2>All Players</h2>
      {players.map((p, idx) => <p key={idx}>{p.name} - {p.score}</p>)}

      <h2>Players with score below 70</h2>
      {filtered.map((p, idx) => <p key={idx}>{p.name} - {p.score}</p>)}
    </div>
  );
};

export default ListofPlayers;
