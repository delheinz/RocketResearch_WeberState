import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt
import io

def read_lvm_file(lvm_path):
    with open(lvm_path, 'r') as f:
        lines = f.readlines()
    
    # Find the last occurrence of ***End_of_Header***
    end_header_indices = [i for i, line in enumerate(lines) if '***End_of_Header***' in line]
    
    if end_header_indices:
        # Start reading data after the last header end
        data_start = end_header_indices[-1] + 1
        data_lines = lines[data_start:]
    else:
        # No header found, use all lines
        data_lines = lines
    
    return data_lines

def convert_lvm_to_csv(df):

    # Column Indices
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

    # Calibrate Pressure Transducer Readings
    pressure_columns = [PS, PU, PI, PC]
    df.iloc[:, pressure_columns] = df.iloc[:, pressure_columns] * 110
    
    # Define Variables for Mass Flow Rate Calculation
    PU_pa = df[PU] * 6894.757 # Convert psig to Pa
    PD_pa = df[PD]/2 * 6894.757 # Divide by 2 because sensor reads 0-10V, but data is 0-5V; then convert to Pa
    R = 8314.34 # Universal Gas Constant in J/(kmol·K)
    M = 31.999 # Molar Mass of O2 in g/mol
    throat_diameter = 0.0127 # in meters
    duct_diameter = 0.0266446 # in meters
    exp_factor = 0.9977 # Expansion Factor for Orifice Plate
    discharge_coeff = 0.607 # Discharge Coefficient for Orifice Plate
    orifice_area = throat_diameter**2 * 3.14159 / 4 # Area of Orifice Plate in m^2
    beta = throat_diameter/duct_diameter # Diameter Ratio of Orifice Plate
    upstream_density = PU_pa/((df[TU] + 273.15)*(R/M)) # Upstream Density in kg/m^3
    
    # Calculate Mass Flow Rate
    mdot = ((upstream_density * (PD_pa * 2))/(1 - beta**2))**0.5 * (orifice_area * discharge_coeff * exp_factor) # Mass Flow Rate in kg/s
    df[PD] = mdot
    
    # Convert POT1 to Valve Percent Open
    y_lb = 9.4
    y_up = 9.2
    percent_open = (df[POT1] +y_lb) / (y_up + y_lb) * 100
    df[POT1] = percent_open

    # Round Decimal Places
    df = df.round(4)

    # Forward fill SETPOINT to repeat values for every row
    df[SETPOINT] = df[SETPOINT].ffill()

    # Output dictionary with new column names
    data_dict = {
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
    }
    
    return pd.DataFrame(data_dict)

def plot_csv_data(df, columns=None):
    if columns is None:
        columns = df.columns[1:]
    
    fig, axes = plt.subplots(len(columns), 1, figsize=(10, 4*len(columns)))
    if len(columns) == 1:
        axes = [axes]
    
    for ax, col in zip(axes, columns):
        ax.plot(df['Time (s)'], df[col])
        ax.set_title(col)
        ax.set_xlabel('Time (s)')
    
    plt.tight_layout()
    return fig

st.title("LVM/CSV Converter & Plotter")

tab1, tab2 = st.tabs(["Convert", "Plot"])

with tab1:
    st.header("Convert LVM to CSV")
    uploaded_file = st.file_uploader("Upload LVM file", type="lvm")
    
    if uploaded_file:
        # Read file and skip header
        lines = uploaded_file.readlines()
        lines = [line.decode('utf-8') if isinstance(line, bytes) else line for line in lines]
        
        end_header_indices = [i for i, line in enumerate(lines) if '***End_of_Header***' in line]
        data_start = end_header_indices[-1] + 1 if end_header_indices else 0
        
        from io import StringIO
        data_content = ''.join(lines[data_start:])
        df = pd.read_csv(StringIO(data_content), sep='\t', header=None, low_memory=False)
        df = df.apply(pd.to_numeric, errors='coerce')
        
        # Delete first 255 rows of data (ignore 50% initial throttle position)
        df = df.drop(range(255))
        df = df.reset_index(drop=True)
        
        # Extract filename
        filename = uploaded_file.name.replace(".lvm", "")
        
        converted_df = convert_lvm_to_csv(df)
        
        st.dataframe(converted_df.head())
        
        csv = converted_df.to_csv(index=False)
        st.download_button(
            label="Download CSV",
            data=csv,
            file_name=f"{filename}.csv",
            mime="text/csv"
        )

with tab2:
    st.header("Plot CSV Data")
    uploaded_file = st.file_uploader("Upload CSV file", type="csv")
    
    if uploaded_file:
        df = pd.read_csv(uploaded_file)
        
        # Initialize session state for plots
        if "plots" not in st.session_state:
            st.session_state.plots = []
        
        st.subheader("Create Plot")
        col1, col2 = st.columns(2)
        
        with col1:
            x_axis = st.selectbox(
                "Select X-axis column",
                df.columns,
                index=0
            )
        
        with col2:
            y_axis = st.selectbox(
                "Select Y-axis column",
                df.columns,
                index=1
            )
        
        y_columns = st.multiselect(
            "Additional Y-axis columns (optional)",
            [col for col in df.columns if col != x_axis],
            default=[]
        )
        
        if y_axis or y_columns:
            fig, ax = plt.subplots(figsize=(10, 6))
            
            all_y_cols = [y_axis] + y_columns
            pot1_col = next((col for col in all_y_cols if "POT1" in col), None)
            other_cols = [col for col in all_y_cols if col != pot1_col]
            
            colors = plt.cm.tab10(range(len(all_y_cols)))
            color_idx = 0
            
            if pot1_col and other_cols:
                # POT1 with other columns - POT1 on right, others on left
                ax.plot(df[x_axis], df[other_cols[0]], label=other_cols[0], linewidth=2, color=colors[color_idx])
                ax.set_ylabel(other_cols[0])
                color_idx += 1
                
                for col in other_cols[1:]:
                    ax.plot(df[x_axis], df[col], label=col, linewidth=2, color=colors[color_idx])
                    color_idx += 1
                
                ax2 = ax.twinx()
                ax2.plot(df[x_axis], df[pot1_col], label=pot1_col, linewidth=2, color=colors[color_idx])
                ax2.set_ylabel(pot1_col)
                ax2.tick_params(axis='y', labelcolor=colors[color_idx])
                
                # Combined legend
                lines1, labels1 = ax.get_legend_handles_labels()
                lines2, labels2 = ax2.get_legend_handles_labels()
                ax.legend(lines1 + lines2, labels1 + labels2, loc="upper left")
            elif pot1_col:
                # POT1 only
                ax.plot(df[x_axis], df[pot1_col], label=pot1_col, linewidth=2, color=colors[color_idx])
                ax.set_ylabel(pot1_col)
                ax.legend()
            else:
                # No POT1
                ax.plot(df[x_axis], df[y_axis], label=y_axis, linewidth=2, color=colors[color_idx])
                color_idx += 1
                for col in y_columns:
                    ax.plot(df[x_axis], df[col], label=col, linewidth=2, color=colors[color_idx])
                    color_idx += 1
                ax.set_ylabel(", ".join(all_y_cols))
                ax.legend()
            
            ax.set_xlabel(x_axis)
            ax.set_title(f"{y_axis} vs {x_axis}")
            ax.grid(True)
            
            plt.tight_layout()
            st.pyplot(fig)
            
            # Save plot button
            if st.button("Save Plot"):
                st.session_state.plots.append({
                    "fig": fig,
                    "title": f"{y_axis} vs {x_axis}",
                    "x_axis": x_axis,
                    "y_axis": y_axis,
                    "y_columns": y_columns,
                    "df": df
                })
                st.success(f"Plot saved! ({len(st.session_state.plots)} total)")
        
        # Display saved plots
        if st.session_state.plots:
            st.subheader(f"Saved Plots ({len(st.session_state.plots)})")
            
            for i, plot_data in enumerate(st.session_state.plots):
                st.write(f"**Plot {i+1}: {plot_data['title']}**")
                st.pyplot(plot_data["fig"])
            
            # Export all plots
            if st.button("Export All Plots as PNG"):
                from PIL import Image
                import io
                
                num_plots = len(st.session_state.plots)
                fig_combined, axes = plt.subplots(
                    num_plots, 1,
                    figsize=(10, 6 * num_plots)
                )
                
                if num_plots == 1:
                    axes = [axes]
                
                for idx, (ax, plot_data) in enumerate(zip(axes, st.session_state.plots)):
                    x_axis = plot_data["x_axis"]
                    y_axis = plot_data["y_axis"]
                    y_cols = plot_data["y_columns"]
                    df_plot = plot_data["df"]
                    
                    all_y_cols = [y_axis] + y_cols
                    pot1_col = next((col for col in all_y_cols if "POT1" in col), None)
                    other_cols = [col for col in all_y_cols if col != pot1_col]
                    
                    colors = plt.cm.tab10(range(len(all_y_cols)))
                    color_idx = 0
                    
                    if pot1_col and other_cols:
                        ax.plot(df_plot[x_axis], df_plot[other_cols[0]], label=other_cols[0], linewidth=2, color=colors[color_idx])
                        ax.set_ylabel(other_cols[0])
                        color_idx += 1
                        
                        for col in other_cols[1:]:
                            ax.plot(df_plot[x_axis], df_plot[col], label=col, linewidth=2, color=colors[color_idx])
                            color_idx += 1
                        
                        ax2 = ax.twinx()
                        ax2.plot(df_plot[x_axis], df_plot[pot1_col], label=pot1_col, linewidth=2, color=colors[color_idx])
                        ax2.set_ylabel(pot1_col)
                        ax2.tick_params(axis='y', labelcolor=colors[color_idx])
                        
                        lines1, labels1 = ax.get_legend_handles_labels()
                        lines2, labels2 = ax2.get_legend_handles_labels()
                        ax.legend(lines1 + lines2, labels1 + labels2, loc="upper left")
                    elif pot1_col:
                        ax.plot(df_plot[x_axis], df_plot[pot1_col], label=pot1_col, linewidth=2, color=colors[color_idx])
                        ax.set_ylabel(pot1_col)
                        ax.legend()
                    else:
                        ax.plot(df_plot[x_axis], df_plot[y_axis], label=y_axis, linewidth=2, color=colors[color_idx])
                        color_idx += 1
                        for col in y_cols:
                            ax.plot(df_plot[x_axis], df_plot[col], label=col, linewidth=2, color=colors[color_idx])
                            color_idx += 1
                        ax.set_ylabel(", ".join(all_y_cols))
                        ax.legend()
                    
                    ax.set_xlabel(x_axis)
                    ax.set_title(plot_data["title"])
                    ax.grid(True)
                
                plt.tight_layout()
                
                buf = io.BytesIO()
                fig_combined.savefig(buf, format="png", dpi=300)
                buf.seek(0)
                
                st.download_button(
                    label="Download All Plots as PNG",
                    data=buf,
                    file_name="all_plots.png",
                    mime="image/png"
                )
            
            # Clear plots button
            if st.button("Clear All Plots"):
                st.session_state.plots = []
                st.rerun()
                