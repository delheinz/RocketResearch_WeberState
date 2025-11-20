# Versions

**2025-11-13 --- v1.0**
    * Convert lvm to csv and generate plots
    * Input columns are as follows:
    TIME = 0 # Time
    PS = 1 # Supply Pressure Transducer
    PU = 2 # Upstream Pressure Transducer
    PI = 3 # Inlet Pressure Transducer
    PC = 4 # Chamber Pressure Transducer
    PD = 5 # Differential Pressure Transducer
    POT1 = 6 # Potentiometer 1 - Valve Position
    LC = 7 # Load Cell
    TU = 8 # Upstream Thermocouple
    TI = 9 # Inlet Thermocouple
    SETPOINT = 10 # Setpoint
    * Output columns are as follows:
    'Time (s)': df[TIME],
    '[PS] SUPPLY PRESSURE TRANSDUCER (psig)': df[PS],
    '[PU] UPSTREAM PRESSURE TRANSDUCER (psig)': df[PU],
    '[PI] INLET PRESSURE TRANSDUCER (psig)': df[PI],
    '[PC] CHAMBER PRESSURE TRANSDUCER (psig)': df[PC],
    '[PD] MASS FLOW RATE (kg/s)': df[PD],
    '[POT1] VALVE PERCENT OPEN (%)': df[POT1],
    '[LC] LOAD CELL THRUST (lbs)': df[LC],
    '[TU] UPSTREAM THERMOCOUPLE (C)': df[TU],
    '[TI] INLET THERMOCOUPLE (C)': df[TI],
    '[SETPOINT] SETPOINT': df[SETPOINT],


**2025-11-19 --- v1.1**
    * Convert lvm to csv and generate plots
    * Skip header rows in lvm file (line 93)
    * Plot setpoint
    * Ignore initial 50% throttle readons (by deleting first 255 rows of data)

