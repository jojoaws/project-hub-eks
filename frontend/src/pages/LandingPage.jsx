import Layout from "../components/Layout";
import { useEffect } from "react";
import api from "../services/api";

function LandingPage() {

  useEffect(() => {

    api.get("/health")
      .then((response) => {
        console.log(response.data);
      })
      .catch((error) => {
        console.error(error);
      });

  }, []);

  return (
    <Layout>

      <h1>🚀 Welcome to ProjectHub</h1>

      <p>
        Showcase projects, connect with creators,
        and build your professional portfolio.
      </p>

      <p>Hosted by Jojo</p>

    </Layout>
  );
}

export default LandingPage;
