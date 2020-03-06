class MovingPoint {

    double xpos, ypos;
    double dx, dy;

    @Override
    public String toString() {
        return String.format("MovingPoint{xpos=%f,ypos=%f,dx=%f,dy=%f}", xpos, ypos, dx, dy);
    }

    public MovingPoint(double xpos, double ypos, double speed, double angle) {
        this.xpos = xpos;
        this.ypos = ypos;
        this.dx = speed * Math.sin(angle);
        this.dy = speed * Math.cos(angle);
    }

    public void move() {
        xpos += dx;
        ypos += dy;
    }

}
