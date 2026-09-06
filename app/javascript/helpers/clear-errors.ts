export default function clearErrors() {

  try {
    document?.querySelector('.alert')?.remove();
  } catch (_error) {
    console.log("TS @ clearErrors failed!");
  }

}