import React, { useState } from "react";

function App() {
  const [status, setStatus] = useState("Not checked");

  const checkBackend = async () => {
    try {
      const response = await fetch("/api/health");

      if (response.ok) {
        const data = await response.json();
        setStatus(data.status);
      } else {
        setStatus("Backend error");
      }
    } catch (error) {
      setStatus("Backend unavailable");
    }
  };

  return (
    <div className="container">
      <div className="card">
        <h1>AWS EKS DevOps Platform</h1>

        <p>React Frontend running on Kubernetes</p>

        <button onClick={checkBackend}>
          Check Backend
        </button>

        <div className="status">
          Backend Status: <strong>{status}</strong>
        </div>
      </div>
    </div>
  );
}

export default App;
