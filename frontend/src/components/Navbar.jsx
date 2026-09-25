import { Link } from "react-router-dom";

function Navbar() {

  const token =
    localStorage.getItem("token");

  const handleLogout = () => {

    localStorage.removeItem(
      "token"
    );

    window.location.href = "/";
  };

  return (
    <nav className="navbar">

      <div className="navbar-links">

        <Link to="/">Home</Link>

        {!token && (
          <>
            <Link to="/about">About</Link>
            <Link to="/contact">Contact</Link>
            <Link to="/login">Login</Link>
            <Link to="/register">Register</Link>
          </>
        )}

        {token && (
          <>
            <Link to="/dashboard">Dashboard</Link>
            <Link to="/profile">Profile</Link>
            <Link to="/projects">Projects</Link>
            <Link to="/about">About</Link>
            <Link to="/contact">Contact</Link>

            <button
              type="button"
              onClick={handleLogout}
            >
              Logout
            </button>
          </>
        )}

      </div>

    </nav>
  );
}

export default Navbar;
