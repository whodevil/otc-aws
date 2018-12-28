import React, {Component} from 'react';
import Button from '@material-ui/core/Button';
import CssBaseline from '@material-ui/core/CssBaseline';

class App extends Component {
    render() {
        return (
            <React.Fragment>
                <CssBaseline/>
                <Button variant="contained" color="Primary">
                    hello world
                </Button>
            </ React.Fragment>
        );
    }
}

export default App;
