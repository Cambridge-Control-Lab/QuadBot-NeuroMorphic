function retVal = Vus_dot(V, Vus, tau_us)
  retVal = 250*(V - Vus) / tau_us;
end