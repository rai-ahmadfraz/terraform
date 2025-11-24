
export const handler = async (event) => {
      console.log("Lambda executed successfully!");
  console.log("Event received:", JSON.stringify(event));
  
    console.log()
    return "Success";
}