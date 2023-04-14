export function fetchWithoutParams(path, method) {
  const token = document.querySelector("meta[name='csrf-token']").content;
  
  return fetch(path, {
    headers: {
      "X-csrf-Token": token,
    },
    method: method,
  }).then((response) => response.json());
}