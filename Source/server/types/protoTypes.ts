interface Username {
    name: string
}

interface UserResponse {
    status: TrackerStatus;
    message: string;
    user?: User;
}

interface TrackerStatus {
    OK: number;
    USER_NOT_FOUND: number;
    PATH_NOT_FOUND: number;
}

interface User {
    name: string;
    currentLocation: Location;
    pathsTraveled: { [key: number]: Path };
}

interface Location {
    x?: number;
    y?: number;
}

interface Path {
    pathTraveled: Location[];
}