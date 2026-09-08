type GameDate = {
  day: string,
  hour: string,
  minute: string
};

type GameDatePayload = {
  type: 'time',
  payload: GameDate
};

export { GameDate, GameDatePayload };