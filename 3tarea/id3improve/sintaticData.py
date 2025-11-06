import pandas as pd
import random

def get_true_label(weather, wind, temp):
    """
    Applies the invented decision tree rules to get the "true" class label.
    """
    if weather == 'Overcast':
        return 'Yes'
    elif weather == 'Sunny':
        if wind == 'Strong':
            return 'No'
        else:  # Weak
            return 'Yes'
    elif weather == 'Rainy':
        if temp == 'Cool':
            return 'No'
        elif temp == 'Mild':
            return 'Yes'
        else:  # Hot
            return 'No'
    return 'No' # Default case, though all should be covered

def apply_noise(attribute_name, current_value, all_values):
    """
    Selects a different value from the list of possible values.
    """
    # Create a list of possible values *except* the current one
    other_values = [val for val in all_values if val != current_value]
    if not other_values:
        return current_value # Should not happen if there's more than one option
    return random.choice(other_values)

def generate_data(num_samples, noise_level, noise_attribute, output_file):
    """
    Generates categorical data based on the decision tree and saves it to CSV.

    Args:
        num_samples (int): Number of data rows to generate.
        noise_level (float): Probability (0.0 to 1.0) of applying noise.
        noise_attribute (str): The specific attribute to apply noise to 
                               (e.g., 'Weather', 'Wind', 'Temperature').
        output_file (str): The name of the CSV file to create (e.g., 'tennis_data.csv').
    """
    
    # Define the possible categorical values for each attribute
    options = {
        'Weather': ['Sunny', 'Rainy', 'Overcast'],
        'Temperature': ['Hot', 'Mild', 'Cool'],
        'Wind': ['Strong', 'Weak']
    }
    
    data = []

    print(f"Generating {num_samples} samples with noise on '{noise_attribute}' at {noise_level*100}% rate...")

    for _ in range(num_samples):
        # 1. Generate the "true" attributes
        true_weather = random.choice(options['Weather'])
        true_temp = random.choice(options['Temperature'])
        true_wind = random.choice(options['Wind'])
        
        # 2. Determine the "true" label based on the rules
        true_label = get_true_label(true_weather, true_wind, true_temp)

        # ---
        # 3. Apply noise to the specified attribute (features)
        #    The label remains the 'true_label' based on the *original* features.
        #    This simulates measurement errors in the data.
        # ---
        
        # Start with the true values
        final_weather = true_weather
        final_temp = true_temp
        final_wind = true_wind
        
        # Check if we should apply noise
        if random.random() < noise_level:
            if noise_attribute == 'Weather':
                final_weather = apply_noise('Weather', true_weather, options['Weather'])
            elif noise_attribute == 'Temperature':
                final_temp = apply_noise('Temperature', true_temp, options['Temperature'])
            elif noise_attribute == 'Wind':
                final_wind = apply_noise('Wind', true_wind, options['Wind'])
        
        # 4. Store the final (potentially noisy) features and the true label
        data.append({
            'Weather': final_weather,
            'Temperature': final_temp,
            'Wind': final_wind,
            'PlayTennis': true_label
        })

    # 5. Convert to DataFrame and save to CSV
    df = pd.DataFrame(data)
    
    # Re-order columns for clarity
    df = df[['Weather', 'Temperature', 'Wind', 'PlayTennis']]
    
    df.to_csv(output_file, index=False)
    print(f"Successfully generated and saved data to '{output_file}'")


# --- Main execution ---
if __name__ == "__main__":
    # --- Configuration ---
    NUM_SAMPLES = 100         # Total rows of data to create
    NOISE_LEVEL = 0.0        # 15% chance to corrupt the specified attribute
    NOISE_ATTRIBUTE = 'Wind'  # Attribute to apply noise to. 
                              # Options: 'Weather', 'Temperature', 'Wind'
    OUTPUT_FILE = 'tennis_data.csv'
    # --- End Configuration ---
    
    generate_data(NUM_SAMPLES, NOISE_LEVEL, NOISE_ATTRIBUTE, OUTPUT_FILE)
    
    # You can also try generating a "clean" dataset for comparison
    # generate_data(
    #   num_samples=100, 
    #   noise_level=0.0, 
    #   noise_attribute='Wind', 
    #   output_file='tennis_data_clean.csv'
    # )