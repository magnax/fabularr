type EventData = {
  readonly type: 'event' | 'project' | 'project.end',
  readonly event_id?: number,
  readonly id?: number,
  readonly progress?: number,
  readonly project_id?: number
}

type DisplayEvent = {
  created_at: any,
  body: string
}

export { EventData, DisplayEvent };