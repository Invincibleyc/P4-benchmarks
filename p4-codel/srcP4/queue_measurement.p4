/*
* Copyright 2018-present Ralf Kundel, Nikolas Eller
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*    http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

control c_add_queue_delay(inout headers hdr, inout standard_metadata_t standard_metadata) {
    apply {
        if (hdr.ipv4.totalLen > 16w500) {
            if (hdr.queue_delay.isValid()) {
                hdr.queue_delay.delay = standard_metadata.deq_timedelta;
            }
        }
    }
}
