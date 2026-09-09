type GameDate = {
  readonly day: string,
  readonly hour: string,
  readonly minute: string
};

type GameDatePayload = {
  readonly type: 'time',
  readonly payload: GameDate
};

export { GameDate, GameDatePayload };