console.log('Ahoy!');

import axios from 'axios';

window.onload = () => {
  const submitButton = document.getElementById('submit') as HTMLButtonElement;
  const addressField = document.getElementById('address') as HTMLInputElement;
  const unitsField = document.getElementById('units') as HTMLInputElement;
  const results = document.getElementById('results') as HTMLDivElement;
  const message = document.getElementById('message') as HTMLDivElement;

  submitButton.addEventListener('click', async () => {
    const address = `address=${encodeURIComponent(addressField.value)}`;
    const units = `units_system=${encodeURIComponent(unitsField.value)}`;

    try {
      const result = await axios.get(`/api/v1/weather_forecast?${address}&${units}`);

      const d = result.data;

      results.innerHTML = `
        <h3>Forecast for: ${d.address}</h23>
        <p>Today is: ${d.current_date}</p>
        <p>Temperature: ${d.current_temperature} ${d.temperature_unit}</p>
        <hr>
        <h4>Next ${d.next_days.length} days forecast:</h4>
        ${d.next_days.map((day: any) => `
          <div>
            <p>${day.date} - Max: ${day.maxTemperature} | Min: ${day.minTemperature}</p>
          </div>
        `).join('')}
        <hr>
        ${ d.cached ? `
            <span>Cached result</span>
            </br>
            <span>Expires at: ${d.expires_at}</span>
          ` : ''
        }
      `;
    } catch (error) {
      console.error(error.response);
      message.innerHTML = `
        <div>${error.response.data.error}</div>
      `;
    }
  });
};
