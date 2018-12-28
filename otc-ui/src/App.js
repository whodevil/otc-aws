import React, {Component} from 'react';
import Button from '@material-ui/core/Button';
import CssBaseline from '@material-ui/core/CssBaseline';
import Amplify from 'aws-amplify';
import aws_exports from './aws-exports';
import { withAuthenticator } from 'aws-amplify-react';
Amplify.configure(aws_exports);

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

export default withAuthenticator(App, {includeGreetings: true});
