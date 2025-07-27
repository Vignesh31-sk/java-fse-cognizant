import { CalculateScore } from "./Components/CalculateScore";

function App()
{
  return(
    <div>
      <CalculateScore 
        Name="John Doe"
        School="Springfield High"
        total={85}
        goal={100}
      />
    </div>
  )
}

export default App;
