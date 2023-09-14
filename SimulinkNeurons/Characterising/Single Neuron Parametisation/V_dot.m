function retVal = V_dot(V, Vs, Vus, I_ext, V0, Vs0, Vus0, g_f, g_s, g_us, C) 
  retVal = 250*((I_ext + g_f*((V-V0)^2) - g_s*((Vs-Vs0)^2) - g_us*((Vus-Vus0)^2))) / C;
end