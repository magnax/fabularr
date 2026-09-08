type EventData = {
  type: 'event' | 'project' | 'project.end',
  event_id: number,
  id: number,
  progress: number,
  project_id: number
}

export { EventData };