import { createConsumer } from "@rails/actioncable";
import { type GameDate, GameDatePayload } from "../types/game-time.ts";

function subscribeTime() {
  const consumer = createConsumer();

  consumer.subscriptions.create({ channel: "TimeChannel" }, {
    received(data: GameDatePayload) {
      console.log("time event received!!");
      console.log(data);
      dispatchTimeEvent(data.payload);
    }
  })
}

function dispatchTimeEvent(data: GameDate) {
  const dd = document.getElementById('header-date-day');
  const dh = document.getElementById('header-date-hour');
  const dm = document.getElementById('header-date-minute');

  if (!dd || !dh || !dm) {
    return;
  }

  if (dd.textContent !== data.day) {
    dd.textContent = data.day;
  }

  if (dh.textContent !== data.hour) {
    dh.textContent = data.hour;
  }

  if (dm.textContent !== data.minute) {
    dm.textContent = data.minute;
  }
}

export { subscribeTime };