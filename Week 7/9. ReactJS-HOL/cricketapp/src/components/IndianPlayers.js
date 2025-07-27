const T20players = ['Virat', 'Rohit', 'Bumrah', 'Pant', 'Surya'];
const RanjiTrophy = ['Pujara', 'Rahane', 'Iyer', 'Saha', 'Jadeja'];

const IndianPlayers = () => {
  const merged = [...T20players, ...RanjiTrophy];

  const oddPlayers = merged.filter((_, i) => i % 2 !== 0);
  const evenPlayers = merged.filter((_, i) => i % 2 === 0);

  return (
    <div>
      <h2>Merged Players</h2>
      <ul>{merged.map((p, i) => <li key={i}>{p}</li>)}</ul>

      <h3>Odd Team</h3>
      <ul>{oddPlayers.map((p, i) => <li key={i}>{p}</li>)}</ul>

      <h3>Even Team</h3>
      <ul>{evenPlayers.map((p, i) => <li key={i}>{p}</li>)}</ul>
    </div>
  );
};

export default IndianPlayers;
