import Login from "./Login";
import { useConnection } from "wagmi";
import Vote from "./Vote";

export default function App() {
  const connection = useConnection();

  return connection.status === "connected" ? <Vote /> : <Login />;
}