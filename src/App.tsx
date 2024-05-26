import "./App.global.css";
import styles from "./App.module.css";

import { Navigation } from "./components/Navigation/Navigation";
import { Display } from "./components/Display/Display";
import { MetaMaskError } from "./components/MetaMaskError/MetaMaskError";

import { useEffect, useState } from "react";
import { useLocation } from "react-router-dom";
import { Footer } from "./components/Footer";






export const App  = () => {
  const location = useLocation();
  const [shouldReload, setShouldReload] = useState(false);

  useEffect(() => {
    // Check if the reload flag is set in the location state
    if (location.state?.reload) {
      setShouldReload(true); // Trigger a reload only if the flag is present

      // Clean up the reload flag after it's used
      window.history.replaceState(null, '', location.pathname); 
    }
  }, [location.state]); // Run the effect only when location.state changes

  useEffect(() => {
    if (shouldReload) {
      window.location.reload();
      setShouldReload(false); // Reset after reload to prevent further reloads
    }
  }, [shouldReload]); // Run the effect only when shouldReload changes


  return (
    
    
      <div >
        
        <Navigation />
        
        
        <Display />

        <MetaMaskError />
        
      </div>
    
    
  );
};

export default App;
